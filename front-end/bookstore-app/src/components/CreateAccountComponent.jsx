import React, { Component } from 'react';
import { Formik, Form, Field, ErrorMessage } from 'formik';
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
			pin : '',
			createFailed : false,
			createFailedMessage : ''
		}
		this.validate = this.validate.bind(this)
		this.createUser = this.createUser.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
	}
  
  render() {
	let { firstName, lastName, dob, gender, email, password, repassword, addressline1, addressline2, city, state, pin } = this.state
    return (
      <div className="CreateAccountComponent">
		<center>
			{this.state.createFailed && <div><font className="alert alert-warning">User Already Exists !</font><br/><br/></div>}
			<div className="container">
                    <Formik
                        initialValues={{ firstName, lastName, dob, gender, email, password, repassword, addressline1, addressline2, city, state, pin }}
                        onSubmit={this.createUser}
                        validateOnChange={false}
						validateOnBlur={false}
                        validate={this.validate}
                        enableReinitialize={true}
                    >
                        {
                            (props) => (
                                <Form>
                                    <ErrorMessage name="firstName" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>First Name</label>
                                        <Field className="form-control" type="text" name="firstName" />
                                    </fieldset>
									
									<ErrorMessage name="lastName" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Last Name</label>
                                        <Field className="form-control" type="text" name="lastName" />
                                    </fieldset>
									
									<ErrorMessage name="dob" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Date of Birth</label>
                                        <Field className="form-control" type="date" name="dob" />
                                    </fieldset>
									
									<ErrorMessage name="gender" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Gender</label>
                                        <Field className="form-control" component="select" name="gender" >
											<option value="" label="Select gender"/>
											<option value="M" label="Male"/>
											<option value="F" label="Female"/>
										</Field>
                                    </fieldset>
									
									<ErrorMessage name="email" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Email id</label>
                                        <Field className="form-control" type="text" name="email" />
                                    </fieldset>
									
									<ErrorMessage name="password" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Password</label>
                                        <Field className="form-control" type="password" name="password" />
                                    </fieldset>
									
									<ErrorMessage name="repassword" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Re-enter password</label>
                                        <Field className="form-control" type="password" name="repassword" />
                                    </fieldset>
									
									<ErrorMessage name="addressline1" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Address line 1</label>
                                        <Field className="form-control" type="text" name="addressline1" />
                                    </fieldset>
									
									<ErrorMessage name="addressline2" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Address line 2</label>
                                        <Field className="form-control" type="text" name="addressline2" />
                                    </fieldset>
									
									<ErrorMessage name="city" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>City</label>
                                        <Field className="form-control" type="text" name="city" />
                                    </fieldset>
									
									<ErrorMessage name="state" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>State</label>
                                        <Field className="form-control" type="text" name="state" />
                                    </fieldset>
									
									<ErrorMessage name="pin" component="div"
                                        className="alert alert-warning" />
                                    <fieldset className="form-group">
                                        <label>Pin code</label>
                                        <Field className="form-control" type="text" name="pin" />
                                    </fieldset>
									
                                    <button className="btn btn-success" type="submit">Sign Up</button>
                                </Form>
                            )
                        }
                    </Formik>
                </div>
		</center>
      </div>
    );
  }
  
  createUser(values)
  {
	  let user = { 
		firstName : values.firstName,
		lastName : values.lastName,
		dob : values.dob,
		gender : values.gender,
		email : values.email,
		password : values.password,
		addressline1 : values.addressline1,
		addressline2 : values.addressline2,
		city : values.state.city,
		pin : values.state.pin
	  }
	  UserAPI.executeCreateUserAPIService(user)
		.then(response => this.handleSuccessfulResponse(response, values))
		.catch(error => this.handleErrorResponse(error))
  }
  
  validate(values)
  {
		let errors = {};
		let message = 'This field is mandatory';
		
		if(!values.firstName)
			errors.firstName = message;
		if(!values.lastName)
			errors.lastName = message;
		if(!values.dob)
			errors.dob = message;
		if(!values.gender)
			errors.gender = message;
		if(!values.email)
			errors.email = message;
		if(!values.password)
			errors.password = message;
		if(!values.repassword)
			errors.repassword = message;
		if(!values.addressline1)
			errors.addressline1 = message;
		if(!values.city)
			errors.city = message;
		if(!values.state)
			errors.state = message;
		if(!values.pin)
			errors.pin = message;
		if(values.password.length < 5)
			errors.password = 'Password should be atleast 5 characters';
		if(!(values.password === values.repassword))
			errors.password = 'Passwords should match';
		
		return errors;
  }
  
  handleSuccessfulResponse(response, values)
  {
	  UserAPI.registerLogin(values.firstName, values.email)
	  this.props.history.push("/home")
  }
  
  handleErrorResponse(error)
  {
	  if(!error.response)
		  this.props.history.push({ pathname: '/error' })
	  else
		this.setState({ createFailed : true })
  }
}

export default CreateAccountComponent;