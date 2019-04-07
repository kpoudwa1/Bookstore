import React, { Component } from 'react';

class ErrorComponent extends Component {
	constructor(props)
	{
		super(props)
	}
	
  render() {
    return (
      <div className="ErrorComponent">
		<h1>An Error occurred. Please contact admin.</h1>
      </div>
    );
  }
}

export default ErrorComponent;