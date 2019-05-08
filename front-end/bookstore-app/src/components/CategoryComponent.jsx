import React, { Component } from 'react';
import { Formik, Form, Field, ErrorMessage } from 'formik';
import SearchAPI from '../api/SearchAPI.js';
import {Link} from 'react-router-dom';

class CategoryComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			categoryId : '',
			books: [],
			isCategorySelected : false
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
		this.validate = this.validate.bind(this)
		this.browse = this.browse.bind(this)
	}
	
  render() {
	let { categoryId } = this.state
    return (
      <div className="BookDetailsComponent">
	  <br/>
		<div className="container">
                <Formik
                    initialValues={{ categoryId}}
                    onSubmit={this.browse}
                    validateOnChange={false}
					validateOnBlur={false}
                    validate={this.validate}
                    enableReinitialize={true}
                >
                    {
                        (props) => (
                            <Form>
                                <ErrorMessage name="categoryId" component="div"
                                    className="alert alert-warning" />
								<fieldset className="form-group">
                                        <label>Please select a category</label>
                                        <Field className="form-control" component="select" name="categoryId" >
											<option value="0" label="Select a category"/>
											<option value="1" label="Arts & Photography"/>
											<option value="2" label="Biographies & Memoirs"/>
											<option value="3" label="Business & Investing"/>
											<option value="4" label="Children's Books"/>
											<option value="5" label="Cookbooks, Food & Wine"/>
											<option value="6" label="History"/>
											<option value="7" label="Literature & Fiction"/>
											<option value="8" label="Mystery & Suspense"/>
											<option value="9" label="Romance"/>
											<option value="10" label="Sci-Fi & Fantasy"/>
											<option value="11" label="Teens & Young Adult"/>
										</Field>
                                </fieldset>										
                                <button className="btn btn-success" type="submit">Browse</button>
                            </Form>
                        )
                    }
                </Formik>
            </div>
			{this.state.isCategorySelected && <div>
			<br/>
		<center>
			<table style={tableStyle} className="table">
			<tbody>
				{
					this.state.books.map(book => 
							<tr key={book.id}>
								<td style={imageWidth}><img alt="{book.title}" width="100px" src={'data:image/jpeg;base64,' + book.image}/></td>
								<td style={padding} align="left"><Link to={"/bookdetails/" + book.id}><h5>{book.title}</h5></Link></td>
							</tr>
					)
				}
			</tbody>
		</table>
		</center>
			</div>}
      </div>
    );
  }
  
  validate(values)
  {
	  console.log(values)
	  let errors = {};
	  let message = 'Invalid category';
	  
	  if(!values.categoryId || values.categoryId === 0)
		  errors.categoryId = message;
	  
	  return errors;
  }
  
  browse(values)
  {
	  console.log('Check session info and add to cart');
	  console.log(values.categoryId);
	  SearchAPI.executeBrowseByCategoryAPIService(values.categoryId)
		.then(response => this.handleSuccessfulResponse(response))
		.catch(error => this.handleErrorResponse(error))
  }
  
  handleSuccessfulResponse(response)
  {
	  this.setState({
		  books: response.data,
		  isCategorySelected : true
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
}

var tableStyle = 
{
	width: '90%'
}

var padding = 
{
	padding: '15px'
}

var imageWidth =
{
	width: '70px',
	paddingLeft: '15px'
}

export default CategoryComponent;