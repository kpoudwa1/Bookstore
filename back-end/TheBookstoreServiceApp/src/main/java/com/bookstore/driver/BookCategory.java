package com.bookstore.driver;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="BOOK_CATEGORY")
public class BookCategory
{
	@Id
	@Column(name="id")
	private int id;
	@Column(name="CATEGORY_NAME")
	private String categoryName;
	
	public BookCategory() 
	{}

	/*
	 * public int getId() { return id; }
	 */

	public void setId(int id) {
		this.id = id;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	@Override
	public String toString()
	{
		return "BookCategory [id=" + id + ", categoryName=" + categoryName + "]";
	}
}