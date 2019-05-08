package com.bookstore.driver;

import java.util.Arrays;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
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
	@Column(name="IMAGE")
	private byte[] image;
	@Column(name="SUMMARY")
	private String summary;
	
	@ManyToOne
    @JoinColumn(name = "CATEGORY_ID")
	private BookCategory bookCategory;
	
	@OneToMany
    @JoinColumn(name = "ID", insertable=false, updatable=false)
	private List<BookFormat> bookFormat;
	
	@ManyToMany(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST, CascadeType.MERGE})
	@JoinTable(name = "BOOK_AUTHOR", joinColumns = { @JoinColumn(name = "BOOK_ID") }, inverseJoinColumns = { @JoinColumn(name = "AUTHOR_ID") })
	private List<Author> authors;
	
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

	public BookCategory getBookCategory()
	{
		return bookCategory;
	}

	public void setBookCategory(BookCategory bookCategory)
	{
		this.bookCategory = bookCategory;
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
	
	public List<BookFormat> getBookFormat()
	{
		return bookFormat;
	}

	public void setBookFormat(List<BookFormat> bookFormat)
	{
		this.bookFormat = bookFormat;
	}

	public List<Author> getAuthors()
	{
		return authors;
	}

	public void setAuthors(List<Author> authors)
	{
		this.authors = authors;
	}

	  @Override public String toString()
	  { 
		  return "Book [id=" + id + ", title=" + title + ", image=" + Arrays.toString(image) + ", summary=" + summary + ", bookCategory=" + bookCategory + ", bookFormat=" + bookFormat + ", authors=" + authors + "]";
	  }
}