package com.bookstore.driver;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


//@Component
@Entity
@Table(name="USER")
public class User
{
	@Id
	@Column(name="id")
	private int id;
	@Column(name="FIRST_NAME")
	private String firstName;
	@Column(name="LAST_NAME")
	private String lastName;
	@Column(name="DOB")
	private Date dob;
	@Column(name="GENDER")
	private char gender;
	@Column(name="EMAIL")
	private String email;
	@Column(name="PASSWORD")
	private String password;
	@Column(name="ADDRESS_LINE1")
	private String addressline1;
	@Column(name="ADDRESS_LINE2")
	private String addressline2;
	@Column(name="CITY")
	private String city;
	@Column(name="STATE")
	private String state;
	@Column(name="PINCODE")
	private String pin;
	
	public User()
	{}

	
	public int getId() 
	{
		return id;
	}


	public void setId(int id) 
	{
		this.id = id;
	}


	public String getFirstName()
	{
		return firstName;
	}

	public void setFirstName(String firstName)
	{
		this.firstName = firstName;
	}

	public String getLastName()
	{
		return lastName;
	}

	public void setLastName(String lastName)
	{
		this.lastName = lastName;
	}

	public Date getDob()
	{
		return dob;
	}

	public void setDob(Date dob)
	{
		this.dob = dob;
	}

	public char getGender()
	{
		return gender;
	}

	public void setGender(char gender)
	{
		this.gender = gender;
	}

	public String getEmail()
	{
		return email;
	}

	public void setEmail(String email)
	{
		this.email = email;
	}

	public String getPassword()
	{
		return password;
	}

	public void setPassword(String password)
	{
		this.password = password;
	}

	public String getAddressline1()
	{
		return addressline1;
	}

	public void setAddressline1(String addressline1)
	{
		this.addressline1 = addressline1;
	}

	public String getAddressline2()
	{
		return addressline2;
	}

	public void setAddressline2(String addressline2)
	{
		this.addressline2 = addressline2;
	}

	public String getCity()
	{
		return city;
	}

	public void setCity(String city)
	{
		this.city = city;
	}

	public String getState()
	{
		return state;
	}

	public void setState(String state)
	{
		this.state = state;
	}

	public String getPin()
	{
		return pin;
	}

	public void setPin(String pin)
	{
		this.pin = pin;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", firstName=" + firstName + ", lastName=" + lastName + ", dob=" + dob + ", gender="
				+ gender + ", email=" + email + ", password=" + password + ", addressline1=" + addressline1
				+ ", addressline2=" + addressline2 + ", city=" + city + ", state=" + state + ", pin=" + pin + "]";
	}
}