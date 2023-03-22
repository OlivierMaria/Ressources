class ProductsController < ApplicationController
    def index
        pp params[:category_id]
        @categories = Category.order(name: :asc).load_async
   @products = Product.with_attached_photo.load_async
   if params[:category_id]
@products = @products.where(category_id: params[:category_id])
   end
   if params[:min_price].present?
@products = @products.where("price >= ?", params[:min_price])
   end
   if params[:max_price].present?
    @products = @products.where("price <= ?", params[:max_price])
    end
    if params[:query_text].present?
        @products = @products.search_full_text(params[:query_text])
        end

        order_by = Product::ORDER_BY.fetch(params[:order_by]&.to_sym, Product::ORDER_BY[:newest])

       @products = @products.order(order_by)
end
    def show
        product
    end

    def new
       @product = Product.new
    end

    def create
@product = Product.new(product_params)

if @product.save
redirect_to products_path, notice: "Ton produit est publié !"
else
render :new, status: :unprocessable_entity 
end
    end

    def edit
product
    end

    def update 
 if product.update(product_params)
            redirect_to products_path, notice: 'Ton Produit est édité'
        else
render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        product.destroy

        redirect_to products_path, notice: 'Ton produit est supprimé', status: :see_other
    end

    private

    def product_params
params.require(:product).permit(:title, :description, :price, :photo, :category_id)
    end

    def product
@product = Product.find(params[:id])
    end
end