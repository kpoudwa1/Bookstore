import React, { Component } from 'react';
import Librarian from '../librarian.jpg';

class ErrorComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			error : {},
		}
	}
	
  render() {
    return (
      <div className="ErrorComponent">
		<center>
			<br/>
			<div><a href="/" className="navbar-brand"><img alt="Turn the page" src={Librarian} width="150" height="150"/></a></div>
			<br/>
			<h4>Oops! Something went wrong. Please contact the admin.</h4>
		</center>
      </div>
    );
  }
}

export default ErrorComponent;