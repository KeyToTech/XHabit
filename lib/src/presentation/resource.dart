enum Status { INITIAL, SUCCESS, ERROR, LOADING }

class Resource<T> {
  Status status;
  T data;
  String message;

  Resource(this.status, this.data, this.message);

  Resource.initial(this.data) {
    status = Status.INITIAL;
    message = null;
  }

  Resource.success(this.data) {
    status = Status.SUCCESS;
    message = 'Success';
  }

  Resource.loading(this.data) {
    status = Status.LOADING;
    message = 'Loading...';
  }

  Resource.error(this.message) {
    status = Status.ERROR;
    data = null;
  }

  Resource.errorWithData(this.message, this.data) {
    status = Status.ERROR;
  }
}
