package com.bookstore.driver;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="AUTHOR")
public class Author 
{
	@Id
	@Column(name="id")
	private int id;
	@Column(name="AUTHOR_NAME")
	private String authorName;
	
	public Author() 
	{}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getAuthorName()
	{
		return authorName;
	}

	public void setAuthorName(String authorName)
	{
		this.authorName = authorName;
	}

	@Override
	public String toString()
	{
		return "Author [id=" + id + ", authorName=" + authorName + "]";
	}
}