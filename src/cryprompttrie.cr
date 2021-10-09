
module CryPrompt
    # this will serve as the new suggestion tree structure. should be easier to maintain, troubleshoot, and fix 
    # it is a modified trie structure. probably not as efficient as using pointers but should be good enough to start with 
    # will not accept duplicate words entered 
    class CryPromptTrie < Reference
        property word : String | Nil
        property description : String | Nil 
        property child_nodes : Array(CryPromptTrie) = Array(CryPromptTrie).new()
    
        def initialize(@word = nil , @description = nil)    
        end
    
        # add a node to the current nodes child nodes do not add a node unless the node has a word. ie only the root node's word can be nil
        def << ( node : CryPromptTrie )
            return nil if node.word.nil?
            @child_nodes << node unless exists?(node.word)
        end
    
        # returns the first child node where the node's children
        def [](word : String)
            @child_nodes.each do |cn|
                return cn if cn.word == word
            end
            return nil
        end

        # adds a nodes children to an existing node merging a node that has a word alreay in the trie 
        private def merge(node : CryPromptTrie)
            return nil if node.word.nil?
            node.child_nodes.each do |cn| 
                @child_nodes[node.word] << cn 
            end
        end


        # checks if a node exists based on the word 
        def exists?(word : String | Nil)
            return nil if word.nil?
            @child_nodes.each do |cn|
                return true if cn.word == word
            end
            return nil 
        end
    
        # returns an array of strings containint the current nodes children's words
        def nodes_to_string_array()
            # return nil if @child_nodes.size < 1 
            ret = [] of String 
            @child_nodes.each do |n|
                if n.word
                    ret << n.word.as(String)
                end
            end
            ret
        end
    
        # returns the child nodes as nodes
        def nodes 
            @child_nodes
        end
    end
end