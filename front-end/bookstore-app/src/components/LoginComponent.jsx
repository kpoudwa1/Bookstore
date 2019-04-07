import React, { Component } from 'react';

class LoginComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			email : 'kedar',
			password : '',
			loginFailed : false,
			loginSuccess : false
		}
		this.handleChange = this.handleChange.bind(this)
		this.logUser = this.logUser.bind(this)
	}
	
  render() {
    return (
      <div className="LoginComponent">
		<label><h1>TODO: Logo</h1></label>
		{this.state.loginFailed && <div><h3><font color="red">Invalid Credentials !</font></h3></div>}
		{this.state.loginSuccess && <div><h3><font color="green">Login successful !</font></h3></div>}
		<center>
			<table frame="box">
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
					<td><input type="submit" value="Create a new account" /></td>
				</tr>
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
	  if(this.state.email === 'kedar' && this.state.password === 'test')
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
	  }
	  console.log(this.state);
  }
}

export default LoginComponent;