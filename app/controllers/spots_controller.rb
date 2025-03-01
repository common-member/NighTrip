class SpotsController < ApplicationController
  before_action :set_spot, only: %i[ edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ index show ]

  # GET /spots or /spots.json
  def index
    @q = Spot.ransack(params[:q])
    @spots = @q.result.includes(:user, :prefecture)
    # 都道府県の選択肢を取得
    @prefectures = Prefecture.all
  end

  # GET /spots/1 or /spots/1.json
  def show
    @spot = Spot.find(params[:id])
  end

  # GET /spots/new
  def new
    @spot = current_user.spots.build
  end

  # GET /spots/1/edit
  def edit
  end

  # POST /spots or /spots.json
  def create
    @spot = current_user.spots.build(spot_params)

    respond_to do |format|
      if @spot.save
        format.html { redirect_to @spot, notice: "Spot was successfully created." }
        format.json { render :show, status: :created, location: @spot }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spots/1 or /spots/1.json
  def update
    respond_to do |format|
      if @spot.update(spot_params)
        format.html { redirect_to @spot, notice: "Spot was successfully updated." }
        format.json { render :show, status: :ok, location: @spot }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spots/1 or /spots/1.json
  def destroy
    @spot.destroy!

    respond_to do |format|
      format.html { redirect_to spots_path, status: :see_other, notice: "Spot was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot
      @spot = current_user.spots.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def spot_params
      params.require(:spot).permit(:name, :prefecture_id, :address, :url, :body, :image)
    end
end
