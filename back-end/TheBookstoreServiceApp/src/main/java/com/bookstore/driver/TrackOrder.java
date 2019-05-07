package com.bookstore.driver;

import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;

public class TrackOrder
{
	private int bookId;
	private byte[] image;
	private String status;
	private Date statusDate;
	
	public TrackOrder()
	{}
	
	public int getBookId() {
		return bookId;
	}

	public void setBookId(int bookId) {
		this.bookId = bookId;
	}

	public byte[] getImage() {
		return image;
	}

	public void setImage(byte[] image) {
		this.image = image;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
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
		return "TrackOrder [bookId=" + bookId + ", image=" + Arrays.toString(image) + ", status=" + status
				+ ", statusDate=" + statusDate + "]";
	}
}