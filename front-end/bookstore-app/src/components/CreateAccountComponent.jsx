import React, { Component } from 'react';
import UserAPI from '../api/UserAPI.js';

class CreateAccountComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			firstName : '',
			lastName : '',
			dob : '',
			gender : '',
			email : '',
			password : '',
			repassword : '',
			addressline1 : '',
			addressline2 : '',
			city : '',
			state : '',
			pin : ''
		}
		
		this.handleChange = this.handleChange.bind(this)
		this.createUser = this.createUser.bind(this)
	}
	
  render() {
    return (
      <div className="CreateAccountComponent">
		<label><h1>TODO: CreateAccountComponent</h1></label><br/>
		<label><h1>TODO: Handle account creation errors</h1></label>
		<center>
			<table frame="box">
				<tbody>
					<tr>
						<td><font color="red">*</font> First Name: </td>
						<td><input type="text" name="firstName" value={this.state.firstName} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> Last Name: </td>
						<td><input type="text" name="lastName" value={this.state.lastName} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> Date of Birth: </td>
						<td><input type="date" name="dob" value={this.state.dob} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> Gender: </td>
						<td><input type="text" name="gender" value={this.state.gender} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> Email id: </td>
						<td><input type="text" name="email" value={this.state.email} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> Password: </td>
						<td><input type="password" name="password" value={this.state.password} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> Re-enter password: </td>
						<td><input type="password" name="repassword" value={this.state.repassword} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> Address line 1: </td>
						<td><input type="text" name="addressline1" value={this.state.addressline1} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;Address line 2: </td>
						<td><input type="text" name="addressline2" value={this.state.addressline2} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> City: </td>
						<td><input type="text" name="city" value={this.state.city} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> State: </td>
						<td><input type="text" name="state" value={this.state.state} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td><font color="red">*</font> Pin code: </td>
						<td><input type="text" name="pin" value={this.state.pin} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td></td>
						<td><input type="submit" value="Sign Up" onClick={this.createUser}/></td>
					</tr>
				</tbody>
			</table>
		</center>
      </div>
    );
  }
  
  handleChange(event)
  {
	  this.setState({
		  [event.target.name] : event.target.value,
	  })
  }
  
  createUser()
  {
	  console.log('Create the user');
	  if(this.state.password === this.state.repassword)
		  console.log('Passwords match')
	  else
		  console.log('Passwords do not match')
	  let user = { 
		firstName : this.state.firstName,
		lastName : this.state.lastName,
		dob : this.state.dob,
		gender : this.state.gender,
		email : this.state.email,
		password : this.state.password,
		addressline1 : this.state.addressline1,
		addressline2 : this.state.addressline2,
		city : this.state.city,
		pin : this.state.pin
	  }
	  UserAPI.executeCreateUserAPIService(user)
		.then(response => this.handleSuccessfulResponse(response))
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log('User created successfully')
  }
}

export default CreateAccountComponent;