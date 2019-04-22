import React, { Component } from 'react';
import UserAPI from '../api/UserAPI.js';
import Logo from '../logo-white.png';
import { Formik, Form, Field, ErrorMessage } from 'formik';
import {Link} from 'react-router-dom';

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
		this.logUser = this.logUser.bind(this)
		this.createAccount = this.createAccount.bind(this)
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
		this.validate = this.validate.bind(this)
	}
	
  render() {
	  let { email, password } = this.state
    return (
      <div className="LoginComponent">
	  <h1>Simple Cart</h1>
      </div>
    );
  }
  
  logUser(values)
  {
	  console.log('Log the user');
	  console.log(values);
	  console.log(this.state);
	  let user = { 
		email : this.state.email,
		password : this.state.password
	  }
	  UserAPI.executeAuthenticateUserAPIService(user)
		.then(response => this.handleSuccessfulResponse(response))
	    .catch(error => this.handleErrorResponse(error))
	  console.log(this.state);
  }
  
  validate(values)
  {
	  console.log(values)
	  let errors = {};
	  let message = 'This field is mandatory';
	  
	  if(!values.email)
		  errors.email = message;
	  if(!values.password)
		  errors.password = message;
	  
	  return errors;
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

const hrStyle = {
  border: 'none',
    height: '1px',
    color: '#333',
    backgroundColor: '#333'
};

export default LoginComponent;