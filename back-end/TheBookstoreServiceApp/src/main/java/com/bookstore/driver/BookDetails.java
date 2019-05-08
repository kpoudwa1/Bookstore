package com.bookstore.driver;

import java.util.Arrays;

public class BookDetails
{
	private int id;
	private String title;
	private String authors;
	private byte[] image;
	private String summary;
	private String category;
	private String isbn10;
	private String isbn13;
	private String bookFormat;
	private float price;
	private int noOfCopies;
	
	
	public BookDetails(Object[] details)
	{
		id = (int) details[0];
		title = (String) details[1];
		authors = (String) details[2];
		image = (byte[]) details[3];
		summary = (String) details[4];
		category = (String) details[5];
		isbn10 = (String) details[6];
		isbn13 = (String) details[7];
		bookFormat = (String) details[8];
		price = (float) details[9];
		noOfCopies = (int) details[10];
	}

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

	public String getCategory()
	{
		return category;
	}

	public void setCategory(String category)
	{
		this.category = category;
	}

	public String getIsbn10()
	{
		return isbn10;
	}

	public void setIsbn10(String isbn10) 
	{
		this.isbn10 = isbn10;
	}

	public String getIsbn13() 
	{
		return isbn13;
	}

	public void setIsbn13(String isbn13)
	{
		this.isbn13 = isbn13;
	}

	public String getBookFormat()
	{
		return bookFormat;
	}

	public void setBookFormat(String bookFormat) 
	{
		this.bookFormat = bookFormat;
	}

	public float getPrice()
	{
		return price;
	}

	public void setPrice(float price)
	{
		this.price = price;
	}

	public int getNoOfCopies()
	{
		return noOfCopies;
	}

	public void setNoOfCopies(int noOfCopies)
	{
		this.noOfCopies = noOfCopies;
	}

	@Override
	public String toString()
	{
		return "BookDetails [id=" + id + ", title=" + title + ", authors=" + authors + ", image="
				+ Arrays.toString(image) + ", summary=" + summary + ", category=" + category + ", isbn10=" + isbn10
				+ ", isbn13=" + isbn13 + ", bookFormat=" + bookFormat + ", price=" + price + ", noOfCopies="
				+ noOfCopies + "]";
	}
}