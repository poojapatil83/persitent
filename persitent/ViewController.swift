//
//  ViewController.swift
//  persitent
//
//  Created by Student 06 on 07/12/18.
//  Copyright © 2018 Student 06. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var list : [Any] = []
    
   //  delegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var DepartmentNo: UITextField!
    @IBOutlet weak var EmpolyeeNo: UITextField!
    @IBOutlet weak var ContactTextField: UITextField!
    @IBOutlet weak var SalaryTextField: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
   
    @IBAction func Insert(_ sender: UIButton) {
        let context = delegate.persistentContainer.viewContext
        let empobj:NSObject = NSEntityDescription.insertNewObject(forEntityName: "Empoyee", into: context)
        
        empobj.setValue(NameTextField.text, forKey: "name")
        empobj.setValue(EmpolyeeNo.text, forKey: "empolyeeNo")
        empobj.setValue(DepartmentNo.text, forKey: "departmentNo")
        empobj.setValue(ContactTextField.text, forKey: "contactNo")
        
        let numberFormatter = NumberFormatter()
        let salary = numberFormatter.number(from: SalaryTextField.text!)
        empobj.setValue(salary, forKey: "salary")
        do
        {
           try context.save()
        }
        catch
        {
            print("Error in inserting data")
        }
        print("data inserted successfully")
        EmpolyeeNo.text = ""
        NameTextField.text = ""
        DepartmentNo.text = ""
        ContactTextField.text = ""
        SalaryTextField.text = ""
      self.readData()
    }
    
    @IBAction func Update(_ sender: UIButton) {
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Empoyee")
        request.predicate = NSPredicate(format: "name = %@", NameTextField.text!)
        request.returnsObjectsAsFaults = false
        
        do
        {
            let result = try context.fetch(request)
           if result.count == 1
            
            {
                let myObject:NSManagedObject = result.first! as! NSManagedObject
               myObject.setValue(NameTextField.text, forKey: "name")
                myObject.setValue(EmpolyeeNo.text, forKey: "empolyeeNo")
                do
                {
                    try context.save()
                }
                catch
                {
                    print(error.localizedDescription)
                }
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        print("update:success")
        EmpolyeeNo.text = ""
        NameTextField.text = ""
        DepartmentNo.text = ""
        ContactTextField.text = ""
        SalaryTextField.text = ""
        self.readData()
    }
    
    
    @IBAction func Delete(_ sender: UIButton) {
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Empoyee")
        request.predicate = NSPredicate(format: "name = %@", NameTextField.text!)
        request.predicate = NSPredicate(format: "empolyeeNo = %@", EmpolyeeNo.text!)
        request.returnsObjectsAsFaults = false
        
        do
        {
            let result = try context.fetch(request)
            if result.count == 1
            {
                let myObject:NSManagedObject = result.first! as! NSManagedObject
                context.delete(myObject)
                do
                {
                    try context.save()
                    
                }
                catch
                {
                    print(error.localizedDescription)
                }
            }
                
            }
        catch
        {
            print(error.localizedDescription)
        }
        print("Delete Sucesfully")
       EmpolyeeNo.text = ""
        NameTextField.text = ""
        DepartmentNo.text = ""
        ContactTextField.text = ""
        SalaryTextField.text = ""
       self.readData()
    }
    override func viewWillAppear(_ animated: Bool) {
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Empoyee")
        do
        {
           list = try context.fetch(request)
            
        }
        catch
        {
            print("error featching")
        }
        self.TableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Empoyee")
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        do
        {
            list = try context.fetch(request)
            
        
        let data : NSManagedObject = list[indexPath.row] as! NSManagedObject
        cell.textLabel?.text = (data.value(forKey: "name") as! String)
        cell.detailTextLabel?.text = (data.value(forKey: "empolyeeNo")as! String)
        }catch
        {
            
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let context = delegate.persistentContainer.viewContext;
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Empoyee");
        
        let data : NSManagedObject = list[indexPath.row] as! NSManagedObject;
        
        request.predicate = NSPredicate(format: "name =%@", (data.value(forKey: "name") as! String));
        request.returnsObjectsAsFaults = false;
        
        
        do{
            let result = try context.fetch(request)
            
            if result.count == 1
            {
                let data : NSManagedObject = result.first as! NSManagedObject;
                NameTextField.text = (data.value(forKey: "name") as! String);
               EmpolyeeNo.text = (data.value(forKey: "empolyeeNo") as! String);
                ContactTextField.text = (data.value(forKey: "contactNo") as! String);
               DepartmentNo.text = (data.value(forKey: "departmentNo") as! String);
                
                //let numFormatter = NumberFormatter()
                let sal = data.value(forKey: "salary");
                
                SalaryTextField.text = (sal as AnyObject).stringValue;
            }
        }catch{
            print("ERROR in updating :: \(error.localizedDescription)");
        }
    }
    
    func readData()
    {
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Empoyee")
        do
        {
            list = try context.fetch(request)
//            for data in list as! [NSManagedObject]
//            {
//                let str = data.value(forKey: "name") as! String
//                let cont = data.value(forKey: "contactNo") as! String
//                let depart = data.value(forKey: "departmentNo") as! String
//                print("\(str)\n\(cont)\n\(depart)")
//            }
            
        }
        catch
        {
            print("Error infeatching data")
        }
        self.TableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

