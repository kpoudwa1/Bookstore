import React, { Component } from 'react';
import UserAPI from '../api/UserAPI.js';
import { Formik, Form, Field, ErrorMessage } from 'formik';

class UpdateAddressComponent extends Component {
  constructor(props)
  {
		super(props)
		this.state = {
			user : {},
			isAddressUpdated : false
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleSuccessfulResponse2 = this.handleSuccessfulResponse2.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
		this.validate = this.validate.bind(this)
		this.updateAddress = this.updateAddress.bind(this)
		this.handleSuccessfulResponse1 = this.handleSuccessfulResponse1.bind(this)
  }
	
  render() {
	  let { addressline1, addressline2, city, state, pin } = this.state.user;
    return (
      <div className="UpdateAddressComponent">
	  <br/>
	  {this.state.isAddressUpdated && <div><br/><font className="alert alert-success">Your address has been updated !</font><br/><br/></div>}
	  <center>
			<div className="container">
                    <Formik
                        initialValues={{ addressline1, addressline2, city, state, pin }}
                        onSubmit={this.updateAddress}
                        validateOnChange={false}
						validateOnBlur={false}
                        validate={this.validate}
                        enableReinitialize={true}
                    >
                        {
                            (props) => (
                                <Form>
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
									
                                    <button className="btn btn-success" type="submit">Update Address</button>
                                </Form>
                            )
                        }
                    </Formik>
                </div>
		</center>
      </div>
    );
  }
  
  componentDidMount()
  {
	UserAPI.executeGetUserDetailsAPIService('kedar@gmail.com')
	.then(response => this.handleSuccessfulResponse(response))
	.catch(error => this.handleErrorResponse(error))
  }
  
  validate(values)
  {
		console.log(values);
		let errors = {};
		let message = 'This field is mandatory';
		
		if(!values.addressline1)
			errors.addressline1 = message;
		if(!values.city)
			errors.city = message;
		if(!values.state)
			errors.state = message;
		if(!values.pin)
			errors.pin = message;
		
		return errors;
  }
  
  updateAddress(values)
  {
	  console.log('update the user');
	  console.log(values);
	  
	  let user = {
		id: this.state.user.id,
		addressline1 : values.addressline1,
		addressline2 : values.addressline2,
		city : values.city,
		state : values.state,
		pin : values.pin
	  }
	  UserAPI.executeupdateAddressAPIService(user)
		.then(response => this.handleSuccessfulResponse2(response))
  }
  
  handleSuccessfulResponse1(response)
  {
	  console.log(response.data)
  }
  
  handleSuccessfulResponse2(response)
  {
	  this.setState({
		  isAddressUpdated: true
	  })
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log(response.data)
	  let userData = response.data;
	  
	  let user = {
		  id : userData.id,
		  addressline1 : userData.addressline1,
		  addressline2 : userData.addressline2,
		  city : userData.city,
		  state : userData.state,
		  pin : userData.pin
	  }
	  
	  this.setState({
		  user
	  })
	  console.log('User:::::::::' + user)
  }
  
  handleErrorResponse(error)
  {
	  if(error.response.status === 404)
		error.response.status = error.response.status + ' Not found';

	  var errorObj =
	  {
		  status: error.response.status,
		  details: error.response.data.details,
		  message: error.response.data.message,
		  timestamp: error.response.data.timestamp
	  }
	  this.props.history.push({
		  pathname: '/error',
		  state: errorObj
	  })
  }
}

export default UpdateAddressComponent;