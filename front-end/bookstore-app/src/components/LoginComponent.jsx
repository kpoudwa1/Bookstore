import React, { Component } from 'react';
import UserAPI from '../api/UserAPI.js';

class LoginComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			email : '',
			password : '',
			loginFailed : false,
			loginSuccess : false
		}
		this.handleChange = this.handleChange.bind(this)
		this.logUser = this.logUser.bind(this)
		this.createAccount = this.createAccount.bind(this)
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
	}
	
  render() {
    return (
      <div className="LoginComponent">
		<label><h1>TODO: Logo</h1></label>
		{this.state.loginFailed && <div><h3><font color="red">Invalid Credentials !</font></h3></div>}
		{this.state.loginSuccess && <div><h3><font color="green">Login successful !</font></h3></div>}
		<center>
			<table frame="box">
				<tbody>
					<tr>
						<td>Email: </td>
						<td><input type="text" name="email" value={this.state.email} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td>Password: </td>
						<td><input type="password" name="password" value={this.state.password} onChange={this.handleChange}/></td>
					</tr>
					<tr>
						<td></td>
						<td><input type="submit" value="Login" onClick={this.logUser}/></td>
					</tr>
					<tr>
						<td><hr/></td>
						<td><hr/></td>
					</tr>
					<tr>
						<td>New user ?</td>
						<td><input type="submit" value="Create a new account" onClick={this.createAccount}/></td>
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
  
  logUser()
  {
	  console.log('Log the user');
	  console.log(this.state);
	  let user = { 
		email : this.state.email,
		password : this.state.password
	  }
	  UserAPI.executeAuthenticateUserAPIService(user)
		.then(response => this.handleSuccessfulResponse(response))
	    .catch(error => this.handleErrorResponse(error))
	  
	  
	  /*if(this.state.email === 'kedar' && this.state.password === 'test')
	  {
		  console.log('Login successful');
		  this.props.history.push("/home")
		  //this.setState({
			//  loginSuccess : true,
			 // loginFailed : false
		  //})
	  }
	  else
	  {
		  console.log('Login failed');
		  this.setState({
			loginFailed : true,
			loginSuccess : false
		})
	  }*/
	  console.log(this.state);
  }
  
  createAccount()
  {
	  console.log('Create a new account');
	  console.log(this.state);
	  this.props.history.push("/createAccount")
	  console.log(this.state);
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log('User logged in successfully')
	  this.props.history.push("/home")
  }
  
  handleErrorResponse(error)
  {
	  if(error.response.status === 404)
		error.response.status = error.response.status + ' Not found';

	  this.setState({
			loginFailed : true,
			loginSuccess : false
		})
  }
}

export default LoginComponent;