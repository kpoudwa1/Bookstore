import React, { Component } from 'react';
import SearchAPI from '../api/SearchAPI.js';

class BookDetailsComponent extends Component {
	constructor(props)
	{
		super(props)
	}
	
  render() {
    return (
      <div className="BookDetailsComponent">
		<label><h2>TODO: Display the details of the book</h2></label>
      </div>
    );
  }
  
  componentDidMount()
  {
    console.log(`GrandChild did mount. ${this.props.match.params.title}`);
	SearchAPI.executeBookDetailsAPIService(this.props.match.params.id)
	.then(response => this.handleSuccessfulResponse(response))
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log(response.data)
	  this.setState({
		  books: response.data
	  })
	  console.log('Books:::::::::')
	  console.log(this.state.books[0][2])
	  
	  return (
		<div>Hi TEST</div>
	  )
  }
}

export default BookDetailsComponent;