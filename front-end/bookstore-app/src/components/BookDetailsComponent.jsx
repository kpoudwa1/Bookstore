import React, { Component } from 'react';
import SearchAPI from '../api/SearchAPI.js';

class BookDetailsComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			book : {}
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
	}
	
  render() {
    return (
      <div className="BookDetailsComponent">
		<label><h2>TODO: Display the details of the book</h2></label>
		<table style={tableStyle}>
			<tbody>
			<tr>
				<td style={padding}>
					<img width="150px" src={'data:image/jpeg;base64,' + this.state.book.image}/>
				</td>
				<td style={padding}>
					<h2 align="left">{this.state.book.title} by {this.state.book.authors}</h2>
					<p align="justify">{this.state.book.summary}</p>
				</td>
			</tr>
			</tbody>
		</table>
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
		  book: response.data
	  })
	  console.log('Books:::::::::')
	  console.log(this.state.book.id)
	  
	  return (
		<div>Hi TEST</div>
	  )
  }
}

var tableStyle = 
{
	width: '90%'
}
var padding = 
{
	padding: '15px'
}

export default BookDetailsComponent;