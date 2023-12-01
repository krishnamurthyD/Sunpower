public class NewsWrapper {
    public String status;
    public Integer totalResults;
    public List<Articles> articles;
    public class Articles {
        public Source source;
        public String author;
        public String title;
        public String description;
        public String url;
        public String urlToImage;
        public String publishedAt;
        public String content;
    }
    public class Source_Z {
        public String id;
        public String name;
    }
    public class Source {
        public String id;
        public String name;
    }
    public static NewsWrapper parse(String json) {
        return (NewsWrapper) System.JSON.deserialize(json, NewsWrapper.class);
    }
}