package com.bookstore.driver;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="BOOK_FORMAT")
public class BookFormat
{
	@Id
	@Column(name="id")
	private int id;
	@Column(name="ISBN_10")
	private String isbn10;
	@Column(name="ISBN_13")
	private String isbn13;
	@Column(name="FORMAT")
	private String format;
	@Column(name="PRICE")
	private float price;
	@Column(name="NUM_COPIES")
	private int noOfCopies;
	
	public BookFormat()
	{}

	/*
	 * public int getId() { return id; }
	 */

	public void setId(int id) {
		this.id = id;
	}

	public String getIsbn10() {
		return isbn10;
	}

	public void setIsbn10(String isbn10) {
		this.isbn10 = isbn10;
	}

	public String getIsbn13() {
		return isbn13;
	}

	public void setIsbn13(String isbn13) {
		this.isbn13 = isbn13;
	}

	/*
	 * public Book getBook() { return book; }
	 * 
	 * public void setBook(Book book) { this.book = book; }
	 */

	public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public float getPrice() {
		return price;
	}

	public void setPrice(float price) {
		this.price = price;
	}

	public int getNoOfCopies() {
		return noOfCopies;
	}

	public void setNoOfCopies(int noOfCopies) {
		this.noOfCopies = noOfCopies;
	}

	@Override
	public String toString() {
		return "BookFormat [id=" + id + ", isbn10=" + isbn10 + ", isbn13=" + isbn13 + ", format=" + format + ", price="
				+ price + ", noOfCopies=" + noOfCopies + "]";
	}
}