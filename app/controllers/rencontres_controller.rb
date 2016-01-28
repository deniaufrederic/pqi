class RencontresController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy_form, :destroy]

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
    @usager = Usager.find_by(id: session[:stored_id])
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
      if @rencontre.type_renc.split(' ').first == "Maraude"
        mar = true
        if !Maraude.find_by(date: @rencontre.date, type_maraude: @rencontre.type_renc).present?
          @maraude = Maraude.create(date: @rencontre.date, type_maraude: @rencontre.type_renc, villes: "")
        end
      else
        mar = false
      end
      rencontre_u = "// #{@rencontre.type_renc} [#{@rencontre.date.strftime("%d/%m/%y")}] //"
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
          if !mar
            err = true
            flash[:danger] = "Erreur : signalement alors que la rencontre annoncée n'est pas une maraude"
            redirect_to id_rencontre_path(:id => @usager.id)
          end
        else
          err = true
          flash[:danger] = "Précisez le type de signalement"
          redirect_to id_rencontre_path(:id => @usager.id)
        end
      else
        params[:rencontre][:signalement] = nil
      end
      if !err
        @usager.fiche = u_fiche if u_fiche
        @usager.save
        @rencontre.save
        flash[:success] = "Rencontre ajoutée avec #{@usager.sexe} #{@usager.nom} #{@usager.prenom}"
        redirect_to usagers_path
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

  def destroy_form
    store_id
    @types =  [ ["Maraude salariés", "Maraude salariés"],
                ["Maraude bénévoles", "Maraude bénévoles"],
                ["Maraude jour", "Maraude jour"],
                ["Rencontre pôle jour", "Rencontre pôle jour"],
                ["Autre", "Autre"]]
    @usager = Usager.find_by(id: session[:stored_id])
  end

  def destroy
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
      redirect_to usagers_path
      session.delete(:stored_id)
    end
  end

  private

    def rencontre_params
      params.require(:rencontre).permit(:date,
                                        :type_renc,
                                        :details,
                                        :signale,
                                        :signalement)
    end
end
