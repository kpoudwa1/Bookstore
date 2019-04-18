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
		<table style={tableStyle}>
			<tbody>
			<tr>
				<td style={padding}>
					<img width="250px" alt="{this.state.book.title}" src={'data:image/jpeg;base64,' + this.state.book.image}/>
				</td>
				<td style={padding}>
					<h2 align="left">{this.state.book.title}<br/></h2>
					<h5 align="left"> by {this.state.book.authors}</h5>
					<h5 align="left">{this.state.book.category}<br/><br/></h5>
					<p align="justify">{this.state.book.summary}</p>
					<hr style={hrStyle}/>
					<p align="justify">
						ISBN10: {this.state.book.isbn10}<br/>
						ISBN13: {this.state.book.isbn13}<br/>
						Format: {this.state.book.format}<br/>
						<b>Price: ${this.state.book.price}</b>
					</p>
					Add to cart
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
	  let bookDetails = response.data;
	  let authors = bookDetails.authors.map(a => " " + a.authorName);
	  authors = authors.toString().substring(0, authors.toString().length - 1);
	  	  
	  let book = {
		  id : bookDetails.id,
		  title : bookDetails.title,
		  image : bookDetails.image,
		  summary : bookDetails.summary,
		  authors : authors,
		  category : bookDetails.bookCategory.categoryName,
		  isbn10 : bookDetails.bookFormat[0].isbn10,
		  isbn13 : bookDetails.bookFormat[0].isbn13,
		  format : bookDetails.bookFormat[0].format,
		  price : bookDetails.bookFormat[0].price,
		  noOfCopies : bookDetails.bookFormat[0].noOfCopies
	  }
	  
	  this.setState({
		  book
	  })
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

const hrStyle = {
  border: 'none',
    height: '1px',
    color: '#333',
    backgroundColor: '#333'
};

export default BookDetailsComponent;