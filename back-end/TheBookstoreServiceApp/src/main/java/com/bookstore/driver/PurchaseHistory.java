package com.bookstore.driver;

import java.util.Arrays;
import java.util.Date;

public class PurchaseHistory
{
	private String title;
	private byte[] image;
	private int quantity;
	private Date orderDate;
	
	public PurchaseHistory()
	{}
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public byte[] getImage() {
		return image;
	}
	public void setImage(byte[] image) {
		this.image = image;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public Date getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}

	@Override
	public String toString() {
		return "PurchaseHistory [title=" + title + ", image=" + Arrays.toString(image) + ", quantity=" + quantity
				+ ", orderDate=" + orderDate + "]";
	}
}