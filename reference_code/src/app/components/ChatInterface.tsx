import { useState, useEffect, useRef } from 'react';
import { motion } from 'motion/react';
import { Send } from 'lucide-react';
import { Button } from '../components/ui/button';
import { Input } from '../components/ui/input';
import { generateQuestions, Question } from '../utils/questionEngine';

interface Message {
  id: string;
  text: string;
  sender: 'bot' | 'user';
  timestamp: number;
}

interface ChatInterfaceProps {
  onComplete: (responses: Record<string, string>) => void;
}

export function ChatInterface({ onComplete }: ChatInterfaceProps) {
  const [messages, setMessages] = useState<Message[]>([]);
  const [responses, setResponses] = useState<Record<string, string>>({});
  const [currentQuestion, setCurrentQuestion] = useState<Question | null>(null);
  const [inputValue, setInputValue] = useState('');
  const [isComplete, setIsComplete] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  useEffect(() => {
    // Initialize with first question
    const flow = generateQuestions('', responses);
    if (flow.questions.length > 0 && messages.length === 0) {
      setCurrentQuestion(flow.questions[0]);
      addBotMessage(flow.questions[0].text);
    }
  }, []);

  const addBotMessage = (text: string) => {
    const message: Message = {
      id: Date.now().toString(),
      text,
      sender: 'bot',
      timestamp: Date.now(),
    };
    setMessages(prev => [...prev, message]);
  };

  const addUserMessage = (text: string) => {
    const message: Message = {
      id: Date.now().toString(),
      text,
      sender: 'user',
      timestamp: Date.now(),
    };
    setMessages(prev => [...prev, message]);
  };

  const handleResponse = (answer: string) => {
    if (!currentQuestion) return;

    // Add user's response to messages
    addUserMessage(answer);

    // Update responses
    const newResponses = {
      ...responses,
      [currentQuestion.id]: answer,
    };
    setResponses(newResponses);

    // Get next question
    const flow = generateQuestions(answer, newResponses);
    
    if (flow.complete) {
      // All done!
      setTimeout(() => {
        addBotMessage("Thanks for checking in! Your pet is happy you're taking care of yourself. 🐾");
        setIsComplete(true);
        onComplete(newResponses);
      }, 500);
    } else if (flow.questions.length > 0) {
      // Ask next question
      setTimeout(() => {
        setCurrentQuestion(flow.questions[0]);
        addBotMessage(flow.questions[0].text);
      }, 500);
    }
  };

  const handleTextSubmit = () => {
    if (inputValue.trim() && currentQuestion?.type === 'text') {
      handleResponse(inputValue);
      setInputValue('');
    }
  };

  return (
    <div className="flex flex-col h-full">
      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map((message, index) => (
          <motion.div
            key={message.id}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            className={`flex ${message.sender === 'user' ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`max-w-[80%] rounded-lg p-3 ${
                message.sender === 'user'
                  ? 'bg-blue-500 text-white'
                  : 'bg-gray-100 text-gray-900'
              }`}
            >
              {message.text}
            </div>
          </motion.div>
        ))}

        {/* Choice buttons */}
        {currentQuestion?.type === 'choice' && currentQuestion.options && !isComplete && (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex flex-wrap gap-2"
          >
            {currentQuestion.options.map((option) => (
              <Button
                key={option}
                onClick={() => handleResponse(option)}
                variant="outline"
                className="rounded-full"
              >
                {option}
              </Button>
            ))}
          </motion.div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Text input for text-type questions */}
      {currentQuestion?.type === 'text' && !isComplete && (
        <div className="p-4 border-t">
          <div className="flex gap-2">
            <Input
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleTextSubmit()}
              placeholder="Type your response..."
              className="flex-1"
            />
            <Button onClick={handleTextSubmit} size="icon">
              <Send className="h-4 w-4" />
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
