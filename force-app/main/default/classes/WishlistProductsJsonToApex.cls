public class WishlistProductsJsonToApex {
    public class Fields {
		public String StockKeepingUnit;
		public String Name;
	}

	public String currencyIsoCode;
	public String currentPageToken;
	public String currentPageUrl;
	public Object hasErrors;
	public List<Items> items;
	public Object nextPageToken;
	public Object nextPageUrl;
	public Object previousPageToken;
	public Object previousPageUrl;

	public class ProductSummary {
		public Fields fields;
		public String name;
		public String productId;
		public Object purchaseQuantityRule;
		public String sku;
		public ThumbnailImage thumbnailImage;
		public VariationAttributes variationAttributes;
	}

	public class ThumbnailImage {
		public String alternateText;
		public Object contentVersionId;
		public String id;
		public String mediaType;
		public Integer sortOrder;
		public Object thumbnailUrl;
		public String title;
		public String url;
	}

	public class Items {
		public Object currencyIsoCode;
		public Object error;
		public Double listPrice;
		public ProductSummary productSummary;
		public Double salesPrice;
		public String wishlistItemId;
	}

	public class VariationAttributes {
	}

	
	public static WishlistProductsJsonToApex parse(String json) {
		return (WishlistProductsJsonToApex) System.JSON.deserialize(json, WishlistProductsJsonToApex.class);
	}

}