class RencontresController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy_form, :destroy_via_form, :destroy, :edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    store_id
    @signalements = [ ["Signalement 115", "Signalement 115"],
                      ["Signalement tiers", "Signalement tiers"],
                      ["Croisé(e) en maraude", "Croisé(e) en maraude"]]
    @types =  [ ["Maraude salariés 1", "Maraude salariés 1"],
                ["Maraude salariés 2", "Maraude salariés 2"],
                ["Maraude bénévoles", "Maraude bénévoles"],
                ["Maraude jour", "Maraude jour"],
                ["Rencontre pôle jour", "Rencontre pôle jour"],
                ["Autre", "Autre"]]
    @prestas = [["Prestation alimentaire", "Prestation alimentaire"],
                ["Vestiaire", "Vestiaire"],
                ["Duvet", "Duvet"],
                ["Hygiène", "Hygiène"]]
    @accomps = [["Accompagnement 115", "Accompagnement 115"],
                ["Accompagnement SIAO", "Accompagnement SIAO"],
                ["Autre", "Autre"]]
    @usager = Usager.find_by(id: session[:stored_id])
    @nb_enf = []
    i = 0
    until i == @usager.enfants.count + 1 do
      @nb_enf << ["#{i}", "#{i}"]
      i += 1
    end
    @rencontre = @usager.rencontres.build
    gon.renc = []
    if @usager.rencontres.any?
      @usager.rencontres.each do |r|
        gon.renc << "#{r.date}"
      end
    end
  end

  def create
    @usager = Usager.find_by(id: session[:stored_id])
    @rencontre = @usager.rencontres.build(rencontre_params)
    if @rencontre.valid?
      if @rencontre.type_renc.split(' ').first == "Maraude" && !@rencontre.prev
        mar = true
        if !Maraude.find_by(date: @rencontre.date, type_maraude: @rencontre.type_renc).present?
          @maraude = Maraude.create(date: @rencontre.date, type_maraude: @rencontre.type_renc, villes: "")
        end
      else
        mar = false
        if @rencontre.dnv
          err = true
          flash[:danger] = "Erreur : Maraude déplacée mais personne non vue alors qu'il ne s'agit pas d'une maraude ou que la rencontre est prévisionnelle"
        end
      end
      rencontre_u = "// #{@rencontre.type_renc} [#{@rencontre.date.strftime("%d/%m/%y")}] //"
      if @rencontre.signale && !@rencontre.signalement.empty?
        rencontre_u << "\n#{@rencontre.signalement}"
      end
      if @rencontre.accomp && !@rencontre.type_accomp.empty?
        rencontre_u << "\n#{@rencontre.type_accomp}"
      end
      rencontre_p = params[:rencontre][:prestas].reject{ |a| a == '0' }.join(' #')
      if rencontre_p && !rencontre_p.empty?
        rencontre_u << "\n#{rencontre_p.split(' #').join(' - ')}"
      end
      if @rencontre.dnv
        rencontre_u << "\nMaraude déplacée mais personne non vue."
      end
      if !@rencontre.details.empty?
        rencontre_u << "\n#{@rencontre.details}"
      else
        rencontre_u << "\nRencontre sans détails."
      end
      rencontre_u << "\n\n\n" unless !@usager.fiche
      rencontre_u << "#{@usager.fiche}"
      u_fiche = rencontre_u
      if @rencontre.signale
        if !@rencontre.signalement.empty?
          if !mar && !@rencontre.prev
            errb = true
            if err
              flash[:danger] << " et signalement alors que la rencontre annoncée n'est pas une maraude"
            else
              flash[:danger] = "Erreur : signalement alors que la rencontre annoncée n'est pas une maraude"
            end
          end
        else
          errb = true
          if err
            flash[:danger] << "et précisez le type de signalement"
          else
            flash[:danger] = "Précisez le type de signalement"
          end
        end
      else
        params[:rencontre][:signalement] = nil
      end
      if @rencontre.accomp
        if !@rencontre.type_accomp.empty?
          if @rencontre.dnv
            errc = true
            if err || errb
              flash[:danger] << " et accompagnement alors que la maraude s'est déplacée sans voir la personne"
            else
              flash[:danger] = "Erreur : accompagnement alors que la maraude s'est déplacée sans voir la personne"
            end
          end
        else
          errc = true
          if err || errb
            flash[:danger] << " et précisez le type d'accompagnement"
          else
            flash[:danger] = "Précisez le type d'accompagnement"
          end
        end
      else
        params[:rencontre][:type_accomp] = nil
      end
      if !err && !errb && !errc
        @usager.fiche = u_fiche if u_fiche
        @usager.save
        @rencontre.nb_enf = nil unless @rencontre.nb_enf
        @rencontre.prestas = rencontre_p
        @rencontre.save
        flash[:success] = "Rencontre ajoutée avec #{@usager.sexe} #{@usager.nom} #{@usager.prenom}"
        redirect_to usagers_path
      else
        redirect_to id_rencontre_path(:id => @usager.id)
      end
    elsif @rencontre.date.blank?
      flash[:danger] = "Renseignez une date"
      redirect_to id_rencontre_path(:id => @usager.id)
    elsif @rencontre.type_renc.empty?
      flash[:danger] = "Précisez un type de rencontre"
      redirect_to id_rencontre_path(:id => @usager.id)
    end
    session.delete(:stored_id)
  end

  def destroy
    @usager = Usager.find(Rencontre.find(params[:id]).usager_id)
    Rencontre.find(params[:id]).destroy
    flash[:success] = "Rencontre supprimée (N'oubliez pas de retirer la rencontre de la fiche de suivi de l'usager si besoin est)"
    redirect_to @usager
  end

  def destroy_form
    store_id
    @types =  [ ["Maraude salariés 1", "Maraude salariés 1"],
                ["Maraude salariés 2", "Maraude salariés 2"],
                ["Maraude bénévoles", "Maraude bénévoles"],
                ["Maraude jour", "Maraude jour"],
                ["Rencontre pôle jour", "Rencontre pôle jour"],
                ["Autre", "Autre"]]
    @usager = Usager.find_by(id: session[:stored_id])
  end

  def destroy_via_form
    @usager = Usager.find_by(id: session[:stored_id])
    r = Rencontre.find_by(usager_id: @usager.id,
                          date: params[:rencontre][:date],
                          type_renc: params[:rencontre][:type_renc])
    if r.nil?
      flash[:danger] = "Cette rencontre n'a pas été trouvée"
      redirect_to id_destroy_path(:id => @usager.id)
    else
      r.destroy
      flash[:success] = "Rencontre supprimée (N'oubliez pas de retirer la rencontre de la fiche de suivi de l'usager si besoin est)"
      redirect_to @usager
      session.delete(:stored_id)
    end
  end

  def edit
    @rencontre = Rencontre.find(params[:id])
    @usager = Usager.find(@rencontre.usager_id)
    @nb_enf = []
    i = 0
    until i == @usager.enfants.count + 1 do
      @nb_enf << ["#{i}", "#{i}"]
      i += 1
    end
    @signalements = [ ["Signalement 115", "Signalement 115"],
                      ["Signalement tiers", "Signalement tiers"],
                      ["Croisé(e) en maraude", "Croisé(e) en maraude"]]
    @types =  [ ["Maraude salariés 1", "Maraude salariés 1"],
                ["Maraude salariés 2", "Maraude salariés 2"],
                ["Maraude bénévoles", "Maraude bénévoles"],
                ["Maraude jour", "Maraude jour"],
                ["Rencontre pôle jour", "Rencontre pôle jour"],
                ["Autre", "Autre"]]
    @prestas = [["Prestation alimentaire", "Prestation alimentaire"],
                ["Vestiaire", "Vestiaire"],
                ["Duvet", "Duvet"],
                ["Hygiène", "Hygiène"]]
    @accomps = [["Accompagnement 115", "Accompagnement 115"],
                ["Accompagnement SIAO", "Accompagnement SIAO"],
                ["Autre", "Autre"]]
    gon.renc = []
    if @usager.rencontres.any?
      @usager.rencontres.each do |r|
        gon.renc << "#{r.date}"
      end
    end
  end

  def update
    @rencontre = Rencontre.find(params[:id])
    @usager = Usager.find(@rencontre.usager_id)
    if @rencontre.update_attributes(rencontre_params)
      if @rencontre.type_renc.split(' ').first == "Maraude" && !@rencontre.prev
        mar = true
        if !Maraude.find_by(date: @rencontre.date, type_maraude: @rencontre.type_renc).present?
          @maraude = Maraude.create(date: @rencontre.date, type_maraude: @rencontre.type_renc, villes: "")
        end
      else
        mar = false
        if @rencontre.dnv
          err = true
          flash[:danger] = "Erreur : Maraude déplacée mais personne non vue alors qu'il ne s'agit pas d'une maraude ou que la rencontre est prévisionnelle"
        end
      end
      rencontre_u = "// #{@rencontre.type_renc} [#{@rencontre.date.strftime("%d/%m/%y")}] //"
      if @rencontre.signale && !@rencontre.signalement.empty?
        rencontre_u << "\n#{@rencontre.signalement}"
      end
      if @rencontre.accomp && !@rencontre.type_accomp.empty?
        rencontre_u << "\n#{@rencontre.type_accomp}"
      end
      rencontre_p = params[:rencontre][:prestas].reject{ |a| a == '0' }.join(' #')
      if rencontre_p && !rencontre_p.empty?
        rencontre_u << "\n#{rencontre_p.split(' #').join(' - ')}"
      end
      if @rencontre.dnv
        rencontre_u << "\nMaraude déplacée mais personne non vue"
      end
      if @usager.enfants.any? && !@rencontre.dnv
        rencontre_u << "\nAvec #{pluralize(@rencontre.nb_enf, "enfant")}."
      end
      if !@rencontre.details.empty?
        rencontre_u << "\n#{@rencontre.details}"
      else
        rencontre_u << "\nRencontre sans détails."
      end
      rencontre_u << "\n\n\n" unless !@usager.fiche
      rencontre_u << "#{@usager.fiche}"
      u_fiche = rencontre_u
      if @rencontre.signale
        if !@rencontre.signalement.empty?
          if !mar && !@rencontre.prev
            errb = true
            if err
              flash[:danger] << " et signalement alors que la rencontre annoncée n'est pas une maraude"
            else
              flash[:danger] = "Erreur : signalement alors que la rencontre annoncée n'est pas une maraude"
            end
          end
        else
          errb = true
          if err
            flash[:danger] << " et précisez le type de signalement"
          else
            flash[:danger] = "Précisez le type de signalement"
          end
        end
      else
        params[:rencontre][:signalement] = nil
      end
      if @rencontre.accomp
        if !@rencontre.type_accomp.empty?
          if @rencontre.dnv
            errc = true
            if err || errb
              flash[:danger] << " et accompagnement alors que la maraude s'est déplacée sans voir la personne"
            else
              flash[:danger] = "Erreur : accompagnement alors que la maraude s'est déplacée sans voir la personne"
            end
          end
        else
          errc = true
          if err || errb
            flash[:danger] << " et précisez le type d'accompagnement"
          else
            flash[:danger] = "Précisez le type d'accompagnement"
          end
        end
      else
        params[:rencontre][:type_accomp] = nil
      end
      if !err && !errb && !errc
        @usager.fiche = u_fiche if u_fiche
        @usager.save
        @rencontre.update_attribute(:nb_enf, 0) unless params[:rencontre][:nb_enf]
        @rencontre.update_attribute(:prestas, params[:rencontre][:prestas].reject{ |a| a == '0' }.join(' #'))
        @rencontre.update_attributes(rencontre_params)
        flash[:success] = "Rencontre mise à jour"
        redirect_to @usager
      else
        redirect_to id_rencontre_path(:id => @usager.id)
      end
    else
      flash[:danger] = "Mise à jour impossible. Veillez à remplir les informations nécessaires (Date, type de rencontre)."
      render 'edit'
    end
  end

  private

    def rencontre_params
      params.require(:rencontre).permit(:date,
                                        :type_renc,
                                        :details,
                                        :signale,
                                        :signalement,
                                        :prev,
                                        :dnv,
                                        :nb_enf,
                                        :accomp,
                                        :type_accomp)
    end
end
