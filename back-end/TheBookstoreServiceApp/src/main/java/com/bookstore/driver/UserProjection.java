package com.bookstore.driver;

import java.util.Date;

public interface UserProjection
{
	public int getId();
	/*public String getFirstName();
	public String getLastName();
	public Date getDob();
	public char getGender();
	public String getEmail();*/
	public String getAddressline1();
	public String getAddressline2();
	public String getCity();
	public String getState();
	public String getPin();
}