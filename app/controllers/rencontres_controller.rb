class RencontresController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    store_id
    @signalements = [ ["Signalement 115", "Signalement 115"],
                      ["Signalement tiers", "Signalement tiers"],
                      ["Croisé(e) en maraude", "Croisé(e) en maraude"]]
    @types =  [ ["Maraude salariés", "Maraude salariés"],
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
        if Maraude.find_by(date: @rencontre.date, type_maraude: @rencontre.type_renc).present?
          @maraude = Maraude.find_by(date: @rencontre.date, type_maraude: @rencontre.type_renc)
          m_rencontres = @maraude.rencontres
          m_rencontres << " ##{@usager.ville} @#{@usager.sexe} #{@usager.nom} #{@usager.prenom}"
        else
          @maraude = Maraude.new(date: @rencontre.date, type_maraude: @rencontre.type_renc, rencontres: "#{@usager.ville} @#{@usager.sexe} #{@usager.nom} #{@usager.prenom}", villes: "", signalements: "")
        end
        if @maraude.cr
          m_cr = @maraude.cr
          m_cr << " ###{@usager.ville} @@#{@usager.sexe} #{@usager.nom} #{@usager.prenom} : "
        else
          m_cr = "#{@usager.ville} @@#{@usager.sexe} #{@usager.nom} #{@usager.prenom} : "
        end
      else
        mar = false
      end
      rencontre_u = "// #{@rencontre.type_renc} [#{@rencontre.date.strftime("%d/%m/%y")}] //"
      if !@rencontre.details.empty?
        rencontre_u << "\n#{@rencontre.details}"
        m_cr << "#{@rencontre.details}\n\n" unless !mar
      else
        rencontre_u << "\nRencontre sans détails."
        m_cr << "Rien de notable.\n\n" unless !mar
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
        @maraude.cr = m_cr if m_cr
        @maraude.save unless !mar
        flash[:success] = "Rencontre ajoutée avec #{@usager.sexe} #{@usager.nom} #{@usager.prenom}"
        redirect_to usagers_path
      end
    elsif !@rencontre.date
      flash[:danger] = "Renseignez une date"
      redirect_to id_rencontre_path(:id => @usager.id)
    elsif !@rencontre.type_renc
      flash[:danger] = "Précisez un type de rencontre"
      redirect_to id_rencontre_path(:id => @usager.id)
    end
    session.delete(:stored_id)
  end

  def edit
  end

  def update
  end

  def destroy
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
