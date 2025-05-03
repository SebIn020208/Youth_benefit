package com.example.youth_benefits_prototype;

public class welfareItem {
    private String title;
    private String description;
    private String target;
    private String link;

    public welfareItem(String title, String description) {
        this.title = title;
        this.description = description;
        this.target = target;
        this.link = link;
    }

    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getTarget() { return target; }
    public String getLink() { return link; }
}

