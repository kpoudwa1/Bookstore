package com.bookstore.driver;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="BOOK")
public class Book
{
	@Id
	@Column(name="id")
	private int id;
	@Column(name="TITLE")
	private String title;
	@Column(name="AUTHORS")
	private String authors;
	@Column(name="CATEGORY")
	private String category;
	@Column(name="IMAGE")
	private byte[] image;
	@Column(name="SUMMARY")
	private String summary;
	
	public Book()
	{}

	public int getId()
	{
		return id;
	}
	
	public void setId(int id) 
	{
		this.id = id;
	}
	
	public String getTitle()
	{
		return title;
	}
	
	public void setTitle(String title) 
	{
		this.title = title;
	}
	
	public String getAuthors() 
	{
		return authors;
	}
	
	public void setAuthors(String authors) 
	{
		this.authors = authors;
	}
	
	public String getCategory() 
	{
		return category;
	}
	
	public void setCategory(String category) 
	{
		this.category = category;
	}
	

	public byte[] getImage()
	{
		return image;
	}

	public void setImage(byte[] image)
	{
		this.image = image;
	}

	public String getSummary() 
	{
		return summary;
	}
	
	public void setSummary(String summary) 
	{
		this.summary = summary;
	}

	@Override
	public String toString()
	{
		return "Book [id=" + id + ", title=" + title + ", authors=" + authors + ", category=" + category + ", image="
				+ image + ", summary=" + summary + "]";
	}
}