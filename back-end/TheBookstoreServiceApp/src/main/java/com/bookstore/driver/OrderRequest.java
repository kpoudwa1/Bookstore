package com.bookstore.driver;

import java.util.HashMap;

import org.springframework.stereotype.Component;

@Component
public class OrderRequest
{
	private int userId;
	private HashMap<Integer, Integer> items;
	
	public OrderRequest()
	{}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public HashMap<Integer, Integer> getItems() {
		return items;
	}

	public void setItems(HashMap<Integer, Integer> items) {
		this.items = items;
	}

	@Override
	public String toString() {
		return "OrdeRequest [userId=" + userId + ", items=" + items + "]";
	}
}