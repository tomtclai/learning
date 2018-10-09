interface UserInterface {
  name: string;
  email: string;
  age: number;
  register();
  payInvoice();
}

class User {
  name: string;
  email: string;
  age: number;

  constructor(name: string, email: string, age: number) {
    this.name = name;
    this.email = email;
    this.age = age;

    console.log("User created: " + this.name);
  }

  register() {
    console.log(this.name + " is registered");
  }

  payInvoice() {
    console.log(this.name + " paying invoice");
  }
}

let john = new User("John doe", "jdoe@gmail.com", 34);

john.register();

class Member extends User {
  id: number;
  constructor(id: number, name: string, email: string, age: number) {
    super(name, email, age);
    this.id = id;
  }

  payInvoice() {
    super.payInvoice();
  }
}

let mike: User = new Member(1, "mike smith", "msmith@gmail.com", 32);

mike.payInvoice();
