class PrivateDataController < ApplicationController
  before_action :authenticate_user!
  before_action :set_private_datum, only: %i[ show update destroy ]

  # GET /private_data
  # GET /private_data.json
  def index
    @private_data = PrivateDatum.all
  end

  # GET /private_data/1
  # GET /private_data/1.json
  def show
  end

  # POST /private_data
  # POST /private_data.json
  def create
    @private_datum = PrivateDatum.new(private_datum_params)

    if @private_datum.save
      render :show, status: :created, location: @private_datum
    else
      render json: @private_datum.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /private_data/1
  # PATCH/PUT /private_data/1.json
  def update
    if @private_datum.update(private_datum_params)
      render :show, status: :ok, location: @private_datum
    else
      render json: @private_datum.errors, status: :unprocessable_entity
    end
  end

  # DELETE /private_data/1
  # DELETE /private_data/1.json
  def destroy
    @private_datum.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_private_datum
      @private_datum = PrivateDatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def private_datum_params
      params.require(:private_datum).permit(:datum)
    end
end
