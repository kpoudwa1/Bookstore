import React, { Component } from 'react';
import UserAPI from '../api/UserAPI.js';

class UpdateAddressComponent extends Component {
  constructor(props)
  {
		super(props)
		this.state = {
			books : []
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
  }
	
  render() {
    return (
      <div className="UpdateAddressComponent">
	  <h1>TODO : Implement Update Address Component</h1>
      </div>
    );
  }
  
  componentDidMount()
  {
	UserAPI.executeGetUserDetailsAPIService('kedar@gmail.com')
	.then(response => this.handleSuccessfulResponse(response))
	.catch(error => this.handleErrorResponse(error))
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log(response.data)
	  console.log('Books:::::::::')
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