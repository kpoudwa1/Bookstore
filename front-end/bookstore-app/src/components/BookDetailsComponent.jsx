import React, { Component } from 'react';
import { Formik, Form, Field, ErrorMessage } from 'formik';
import SearchAPI from '../api/SearchAPI.js';
import UserAPI from '../api/UserAPI.js';

class BookDetailsComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			book : {},
			quantity : 0
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
		this.validate = this.validate.bind(this)
		this.addToCart = this.addToCart.bind(this)
	}
	
  render() {
	let id = this.state.book.id;
	let quantity = this.state.quantity;
    return (
      <div className="BookDetailsComponent">
		<table style={tableStyle}>
			<tbody>
			<tr key={this.state.book.id}>
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
				</td>
			</tr>
			</tbody>
		</table>
		<div className="container">
                <Formik
                    initialValues={{ id, quantity}}
                    onSubmit={this.addToCart}
                    validateOnChange={false}
					validateOnBlur={false}
                    validate={this.validate}
                    enableReinitialize={true}
                >
                    {
                        (props) => (
                            <Form>
                                <ErrorMessage name="quantity" component="div"
                                    className="alert alert-warning" />
								<fieldset className="form-group">
                                        <label>Quantity</label>
                                        <Field className="form-control" component="select" name="quantity" >
											<option value="0" label="Select quantity"/>
											<option value="1" label="1"/>
											<option value="2" label="2"/>
											<option value="3" label="3"/>
											<option value="4" label="4"/>
											<option value="5" label="5"/>
											<option value="6" label="6"/>
											<option value="7" label="7"/>
											<option value="8" label="8"/>
											<option value="9" label="9"/>
											<option value="10" label="10"/>
										</Field>
                                </fieldset>										
                                <button className="btn btn-success" type="submit">Add to cart</button>
                            </Form>
                        )
                    }
                </Formik>
            </div>
      </div>
    );
  }
  
  componentDidMount()
  {
    console.log(`GrandChild did mount. ${this.props.match.params.title}`);
	SearchAPI.executeBookDetailsAPIService(this.props.match.params.id)
	.then(response => this.handleSuccessfulResponse(response))
	.catch(error => this.handleErrorResponse(error))
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log(response)
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
  
  handleErrorResponse(error)
  {
	  console.log(error);
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
  
  validate(values)
  {
	  console.log(values)
	  let errors = {};
	  let message = 'Invalid quantity';
	  
	  if(!values.quantity || values.quantity === 0)
		  errors.quantity = message;
	  
	  return errors;
  }
  
  addToCart(values)
  {
	  console.log('Check session info and add to cart');
	  if(!UserAPI.isUserLoggedIn())
	  {
		  console.log('User Not found');
		  this.props.history.push(`/login`)
	  }
	  else
	  {
		  console.log('User found');
		  console.log(values);
		  UserAPI.addItem(values.id, values.quantity);
	  }
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