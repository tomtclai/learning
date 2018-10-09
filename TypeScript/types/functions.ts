function getSum(num1: number, num2: number) {
  return num1 + num2;
}

let mySum = function(num1: any, num2: any): number {
  num1 = parseIfNeeded(num1);
  num2 = parseIfNeeded(num2);
  return num1 + num2;
};

let parseIfNeeded = function(num: any): number | undefined {
  if (typeof num == "string") {
    return parseInt(num);
  }
  if (typeof num == "number") {
    return num;
  }
  return undefined;
};

console.log(mySum(3, 5));

function getName(firstName: string, lastName?: string): string {
  if (lastName == undefined) {
    return firstName;
  }
  return firstName + " " + lastName;
}

console.log(getName("John"));

function myVoid(): void {
  return;
}
