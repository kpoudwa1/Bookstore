package com.bookstore.driver;

import java.util.HashMap;

import org.springframework.stereotype.Component;

@Component
public class OrderRequest
{
	private String email;
	private HashMap<Integer, Integer> items;
	
	public OrderRequest()
	{}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public HashMap<Integer, Integer> getItems() {
		return items;
	}

	public void setItems(HashMap<Integer, Integer> items) {
		this.items = items;
	}

	@Override
	public String toString() {
		return "OrderRequest [email=" + email + ", items=" + items + "]";
	}
}