package com.bookstore.driver;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="TRACK_ORDER")
public class Order
{
	@Id
	@Column(name="id")
	private int id;
	@Column(name="USER_ID")
	private int userId;
	@Column(name="BOOK_ID")
	private int bookId;
	@Column(name="QUANTITY")
	private int quantity;
	@Column(name="STATUS")
	private int status;
	@Column(name="STATUS_DATE")
	private Date statusDate;
	
	public Order() 
	{}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getBookId() {
		return bookId;
	}

	public void setBookId(int bookId) {
		this.bookId = bookId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public Date getStatusDate() {
		return statusDate;
	}

	public void setStatusDate(Date statusDate) {
		this.statusDate = statusDate;
	}

	@Override
	public String toString() {
		return "Order [id=" + id + ", userId=" + userId + ", bookId=" + bookId + ", quantity=" + quantity + ", status="
				+ status + ", statusDate=" + statusDate + "]";
	}
}