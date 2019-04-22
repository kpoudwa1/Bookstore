import React, { Component } from 'react';

class LogoutComponent extends Component {
	constructor(props)
	{
		super(props)
	}
	
  render() {
    return (
      <>
		<h1>You have been logged out successfully !</h1>
		<div className="container">
			Thank You
		</div>
      </>
    );
  }
}

export default LogoutComponent;