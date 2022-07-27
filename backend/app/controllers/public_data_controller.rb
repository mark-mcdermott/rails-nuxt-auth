class PublicDataController < ApplicationController
  before_action :set_public_datum, only: %i[ show update destroy ]

  # GET /public_data
  # GET /public_data.json
  def index
    @public_data = PublicDatum.all
  end

  # GET /public_data/1
  # GET /public_data/1.json
  def show
  end

  # POST /public_data
  # POST /public_data.json
  def create
    @public_datum = PublicDatum.new(public_datum_params)

    if @public_datum.save
      render :show, status: :created, location: @public_datum
    else
      render json: @public_datum.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /public_data/1
  # PATCH/PUT /public_data/1.json
  def update
    if @public_datum.update(public_datum_params)
      render :show, status: :ok, location: @public_datum
    else
      render json: @public_datum.errors, status: :unprocessable_entity
    end
  end

  # DELETE /public_data/1
  # DELETE /public_data/1.json
  def destroy
    @public_datum.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_public_datum
      @public_datum = PublicDatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def public_datum_params
      params.require(:public_datum).permit(:datum)
    end
end
