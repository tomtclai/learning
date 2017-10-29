//https://leetcode.com/problems/map-sum-pairs/submissions/1
class MapSum {
    class TrieNode {
        Map<Character, TrieNode> children;
        int value;
        public TrieNode() {
            children = new HashMap<Character, TrieNode>();
            value = 0;
        }
    }
        
    /** Initialize your data structure here. */
    TrieNode root;
    public MapSum() {
        root = new TrieNode();
    }
    
    public void insert(String key, int val) {
        TrieNode curr = root;
        for (char c: key.toCharArray()) {
            TrieNode next = curr.children.get(c);
            if (next == null) {
                next = new TrieNode();
                curr.children.put(c, next);
            }
            curr = next;
        }
        curr.value = val;
    }
    
    public int sum(String prefix) {
        TrieNode curr = root;
        for (char c: prefix.toCharArray()) {
            TrieNode next = curr.children.get(c);
            if (next == null) {
                return 0;
            }
            curr = next;
        }
        
        return dfs(curr);
    }
    
    private int dfs(TrieNode root) {
        int sum = 0;
        for (char c: root.children.keySet()) {
            sum += dfs(root.children.get(c));
        }
        return sum + root.value;
    }
}