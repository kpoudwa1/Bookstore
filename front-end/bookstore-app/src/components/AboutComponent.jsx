import React, { Component } from 'react';
import Logo from '../logo-white.png';

class AboutComponent extends Component {
  render() {
    return (
      <center>
		<div className="LoginComponent" style={divStyle}>
			<br/>
			<div><a href="/" className="navbar-brand"><img alt="Turn the page" src={Logo} width="150" height="150"/></a></div>
			<br/>
			<p align="justify">Turn the page is an online book store that helps you explore the bookstore without ever leaving the comfort of your couch. Ordering your favorite books is simple and just a few clicks away. We have multiple popular genres like Arts & Photography, Biographies & Memoirs, Literature & Fiction and many more. We are expanding rapidly to add more books to our collection just for you.</p>
			<p align="justify">We hope you enjoy the Turn the page!</p>
		</div>
	  </center>
    );
  }
}

var divStyle = 
{
	width: '60%'
}

export default AboutComponent;