public class WishlistJsonToApexConverter {

	public Object displayedList;
	public List<Summaries> summaries;
	public Integer wishlistCount;

	public class Summaries {
	}

	
	public static WishlistJsonToApexConverter parse(String json) {
		return (WishlistJsonToApexConverter) System.JSON.deserialize(json, WishlistJsonToApexConverter.class);
	}
}