// https://leetcode.com/problems/employee-importance/description/
private HashMap<Integer, Employee> hmap = new HashMap<Integer, Employee>();

public int getImportance(List<Employee> employees, int id) {
    for (Employee employee: employees) {
        hmap.put(employee.id, employee);
    }
    return getImportance(hmap.get(id)); // couldnt find it
}
private int getImportance(Employee employee) {
    if (employee == null) return 0;
    int importance = employee.importance;
    for (int subordinateID: employee.subordinates) {
        Employee subordinate = hmap.get(subordinateID);
        importance += getImportance(subordinate);
    }
    return importance;
}