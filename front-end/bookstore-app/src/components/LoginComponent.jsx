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
		{this.state.loginSuccess && <div><h3><font color="green">Login successful !</font></h3></div>}
		<center>
			<div><a href="/" className="navbar-brand"><img alt="Turn the page" src={Logo} width="150" height="150"/></a></div>
			{this.state.loginFailed && <div><br/><font className="alert alert-danger">Invalid Credentials !</font><br/><br/></div>}
			<div className="container">
                <Formik
                    initialValues={{ email, password }}
                    onSubmit={this.logUser}
                    validateOnChange={false}
                    validate={this.validate}
                    enableReinitialize={true}
                >
                    {
                        (props) => (
                            <Form>
                                <ErrorMessage name="email" component="div"
                                    className="alert alert-warning" />
                                <fieldset className="form-group">
                                    <label>Email</label>
                                    <Field className="form-control" type="text" name="email" />
                                </fieldset>
					
					<ErrorMessage name="password" component="div"
                                    className="alert alert-warning" />
                                <fieldset className="form-group">
                                    <label>Password</label>
                                    <Field className="form-control" type="password" name="password" />
                                </fieldset>
					
                                <button className="btn btn-success" type="submit">Login</button>
					<hr style={hrStyle}/>
					<Link to={"/createAccount"}>New User?</Link>
                            </Form>
                        )
                    }
                </Formik>
            </div>
		</center>
      </div>
    );
  }
  
  logUser(values)
  {
	  console.log('Log the user');
	  console.log(values);
	  console.log(this.state);
	  let user = { 
		email : values.email,
		password : values.password
	  }
	  UserAPI.executeAuthenticateUserAPIService(user)
		.then(response => this.handleSuccessfulResponse(response, values))
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
  
  handleSuccessfulResponse(response, values)
  {
	  console.log('User logged in successfully');
	  console.log(response.data);
	  UserAPI.registerLogin(response.data.firstName, response.data.email)//values.email)
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