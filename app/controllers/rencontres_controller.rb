class RencontresController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :new_groupe, :post_groupe, :edit_form, :post_form, :destroy, :edit, :update]

  def new
    store_id
    @signalements = [ ["Signalement 115", "Signalement 115"],
                      ["Signalement tiers", "Signalement tiers"],
                      ["Croisé(e) en maraude", "Croisé(e) en maraude"]]
    @types =  [ ["Maraude salariés 1", "Maraude salariés 1"],
                ["Maraude salariés 2", "Maraude salariés 2"],
                ["Maraude bénévoles", "Maraude bénévoles"],
                ["Maraude jour", "Maraude jour"],
                ["Maraude médicale", "Maraude médicale"],
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
    gon.renc = []
    if @usager.rencontres.any?
      @usager.rencontres.each do |r|
        gon.renc << "#{r.date.strftime('%d/%m/%Y')}"
      end
    end
    @rencontre = @usager.rencontres.build
  end

  def create
    @usager = Usager.find_by(id: session[:stored_id])
    @rencontre = @usager.rencontres.build(rencontre_params)
    @rencontre.user_id = current_user.id
    if session.has_key?('groupe')
      @rencontre.date = session[:date]
      @rencontre.type_renc = session[:type_renc]
    else
      @rencontre.date = params[:rencontre][:date].to_date.strftime("%F")
    end
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
      if @usager.enfants.any? && !@rencontre.dnv
        rencontre_u << "\nAvec #{@rencontre.nb_enf} #{"enfant".pluralize(@rencontre.nb_enf)}."
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
        if session.has_key?('usagers_ids')
          session[:groupe] = true
          if session[:usagers_ids] == []
            session.delete(:usagers_ids)
          end
        else
          session.delete(:date)
          session.delete(:type_renc)
        end
        @rencontre.save
        flash[:success] = "Rencontre ajoutée avec #{@usager.sexe} #{@usager.nom} #{@usager.prenom}"
        if !session[:usagers_ids]
          if @usager.groupe && @usager.groupe.usagers.count > 1 && !session[:groupe]
            session[:type_renc] = @rencontre.type_renc
            session[:date] = @rencontre.date
            redirect_to id_groupe_path(:id => @usager.id)
          else
            redirect_to @usager
          end
          if session[:groupe]
            session.delete(:groupe)
          end
        else
          redirect_to id_rencontre_path(:id => session[:usagers_ids].pop)
        end
        session.delete(:stored_id)
      else
        redirect_to id_rencontre_path(:id => @usager.id)
      end
    elsif params[:rencontre][:date].blank?
      flash[:danger] = "Renseignez une date"
      redirect_to id_rencontre_path(:id => @usager.id)
    elsif params[:rencontre][:type_renc].empty?
      flash[:danger] = "Précisez un type de rencontre"
      redirect_to id_rencontre_path(:id => @usager.id)
    elsif Rencontre.where(usager_id: @usager.id, date: params[:rencontre][:date], type_renc: params[:rencontre][:type_renc])
      flash[:danger] = "Cette rencontre existe déjà"
      redirect_to id_rencontre_path(:id => @usager.id)
    end
  end

  def new_groupe
    store_id
    u = Usager.find(session[:stored_id])
    @groupe = u.groupe
    @usagers = @groupe.usagers.select{ |usager| usager.id != u.id }
  end

  def post_groupe
    session[:usagers_ids] = params[:rencontre][:usagers].reject{ |a| a == '0' }
    session.delete(:stored_id)
    session[:groupe] = true
    redirect_to id_rencontre_path(:id => session[:usagers_ids].pop)
  end

  def destroy
    r = Rencontre.find(params[:id])
    @usager = Usager.find(r.usager_id)
    if current_user.benev? && r.type_renc != "Maraude bénévoles"
      flash[:danger] = "Accès restreint"
      redirect_to id_rencontre_edit_path(id: @usager.id)
    else
      if @usager.fiche.present?
        u_del = @usager.fiche.split("//")
        rank = u_del.index(" #{r.type_renc} [#{r.date.strftime("%d/%m/%y")}] ")
        if rank
          while rank != nil
            u_del = u_del[0..(rank-1)].concat(u_del[(rank+2)..(u_del.length-1)])
            rank = u_del.index(" #{r.type_renc} [#{r.date.strftime("%d/%m/%y")}] ")
          end
        end
        @usager.fiche = "#{u_del.join("//")}"
        @usager.save
      end
      r.destroy
      flash[:success] = "Rencontre supprimée (Vérifiez que la rencontre a bien été retirée dans la fiche suivi de l'usager)"
      redirect_to @usager
    end
  end

  def edit_form
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
    store_id
    @types =  [ ["Maraude salariés 1", "Maraude salariés 1"],
                ["Maraude salariés 2", "Maraude salariés 2"],
                ["Maraude bénévoles", "Maraude bénévoles"],
                ["Maraude jour", "Maraude jour"],
                ["Maraude médicale", "Maraude médicale"],
                ["Rencontre pôle jour", "Rencontre pôle jour"],
                ["Autre", "Autre"]]
    @usager = Usager.find_by(id: session[:stored_id])
    session.delete(:stored_id)
  end

  def post_form
    store_id
    @usager = Usager.find(session[:stored_id])
    r = Rencontre.find_by(usager_id: @usager.id,
                          date: params[:rencontres][:date].to_date.strftime("%F"),
                          type_renc: params[:rencontres][:type_renc])
    if current_user.benev? && r.type_renc != "Maraude bénévoles"
      flash[:danger] = "Accès restreint"
      redirect_to id_rencontre_edit_path(id: @usager.id)
    else
      if params[:suppr_renc]
        if r.nil?
          flash[:danger] = "Cette rencontre n'a pas été trouvée"
          redirect_to id_rencontre_edit_path(id: @usager.id)
        else
          r.destroy
          if @usager.fiche.present?
            u_del = @usager.fiche.split("//")
            rank = u_del.index(" #{r.type_renc} [#{r.date.strftime("%d/%m/%y")}] ")
            if rank
              while rank != nil
                u_del = u_del[0..(rank-1)].concat(u_del[(rank+2)..(u_del.length-1)])
                rank = u_del.index(" #{r.type_renc} [#{r.date.strftime("%d/%m/%y")}] ")
              end
            end
            @usager.fiche = "#{u_del.join("//")}"
            @usager.save
          end
          flash[:success] = "Rencontre supprimée (Vérifiez que la rencontre a bien été retirée dans la fiche suivi de l'usager)"
          redirect_to @usager
        end
      elsif params[:edit_renc]
        if r.nil?
          flash[:danger] = "Cette rencontre n'a pas été trouvée"
          redirect_to id_rencontre_edit_path(id: @usager.id)
        else
          redirect_to edit_rencontre_path(r)
        end
      end
    end
    session.delete(:stored_id)
  end


  def edit
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
    @rencontre = Rencontre.find(params[:id])
    @usager = Usager.find(@rencontre.usager_id)
    if current_user.benev? && @rencontre.type_renc != "Maraude bénévoles"
      flash[:danger] = "Accès restreint"
      redirect_to id_rencontre_edit_path(id: @usager.id)
    else
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
                  ["Maraude médicale", "Maraude médicale"],
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
          gon.renc << "#{r.date.strftime('%d/%m/%Y')}"
        end
      end
    end
  end

  def update
    @rencontre = Rencontre.find(params[:id])
    @usager = Usager.find(@rencontre.usager_id)
    if current_user.benev? && @rencontre.type_renc != "Maraude bénévoles"
      flash[:danger] = "Accès restreint"
      redirect_to id_rencontre_edit_path(id: @usager.id)
    else
      if @rencontre.update_attributes(rencontre_params)
        @rencontre.update_attribute(:date, params[:rencontre][:date].to_date.strftime("%F"))
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
          rencontre_u << "\nAvec #{@rencontre.nb_enf} #{"enfant".pluralize(@rencontre.nb_enf)}."
        end
        if !@rencontre.details.empty?
          rencontre_u << "\n#{@rencontre.details}"
        else
          rencontre_u << "\nRencontre sans détails."
        end
        rencontre_u << "\n\n\n" unless !@usager.fiche
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
          if @usager.fiche.present?
            u_del = @usager.fiche.split("//")
            rank = u_del.index(" #{@rencontre.type_renc} [#{@rencontre.date.strftime("%d/%m/%y")}] ")
            if rank
              while rank != nil
                u_del = u_del[0..(rank-1)].concat(u_del[(rank+2)..(u_del.length-1)])
                rank = u_del.index(" #{@rencontre.type_renc} [#{@rencontre.date.strftime("%d/%m/%y")}] ")
              end
            end
            rencontre_u << "#{u_del.join("//")}"
          end
          @usager.fiche = rencontre_u if rencontre_u
          @usager.save
          @rencontre.update_attributes(rencontre_params)
          @rencontre.update_attribute(:nb_enf, 0) unless params[:rencontre][:nb_enf]
          @rencontre.update_attribute(:prestas, params[:rencontre][:prestas].reject{ |a| a == '0' }.join(' #'))
          @rencontre.update_attribute(:date, params[:rencontre][:date].to_date.strftime("%F"))
          flash[:success] = "Rencontre mise à jour (Vérifiez que la rencontre avant mise à jour dans la fiche de suivi de l'usager a bien été retirée)"
          redirect_to @usager
        else
          redirect_to id_rencontre_path(:id => @usager.id)
        end
      else
        flash[:danger] = "Mise à jour impossible. Veillez à remplir les informations nécessaires (Date, type de rencontre). La rencontre existe peut-être déjà (mêmes date et type de rencontre avec l'usager)."
        render 'edit'
      end
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
                                        :type_accomp,
                                        :prestas)
    end
end
