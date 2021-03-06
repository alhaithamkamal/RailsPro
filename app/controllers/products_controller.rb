class ProductsController < ApplicationController
  before_action :authenticate_admin_user! , :except=>[:show,:index]  
  def index
    @products = Product.search(params[:query])
  end
  def show
    @product = Product.find(params[:id])
  end

  def new
    if Store.find_by(seller_id: current_admin_user.id)
    @product = Product.new
  else
    redirect_to "/admin/stores/new"
  end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)
    seller = current_admin_user.id
    store = Store.find_by(seller_id: seller)
    @product.update(seller_id: seller)
    @product.update(store_id: store.id)
    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
      @product = Product.find(params[:id])
      @product.destroy
  
      redirect_to products_path
  end

  private 
    def product_params
      params.require(:product).permit(:name,:price,:description,:quantity,:product_image, :remove_product_image, :category_id, :brand_id , :query)
    end

end
