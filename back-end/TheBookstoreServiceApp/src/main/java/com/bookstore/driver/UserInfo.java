package com.bookstore.driver;

public class UserInfo
{
	private String firstName;
	private String email;

	public UserInfo()
	{}

	public String getFirstName()
	{
		return firstName;
	}

	public void setFirstName(String firstName)
	{
		this.firstName = firstName;
	}

	public String getEmail() 
	{
		return email;
	}

	public void setEmail(String email) 
	{
		this.email = email;
	}

	@Override
	public String toString()
	{
		return "UserInfo [firstName=" + firstName + ", email=" + email + "]";
	}
}