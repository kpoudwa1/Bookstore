import React, { Component } from 'react';

class ErrorComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			error : {}
		}
	}
	
  render() {
    return (
      <div className="ErrorComponent" align="left">
		<h3>{this.props.location.state.status}</h3>
		<br/>
		<h4>Details: </h4>
		<h4>{this.props.location.state.message}</h4>
		<h4>Timestamp: {this.props.location.state.timestamp}</h4>
      </div>
    );
  }
  
}

export default ErrorComponent;