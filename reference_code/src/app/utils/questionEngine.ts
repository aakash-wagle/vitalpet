export interface Question {
  id: string;
  text: string;
  type: 'choice' | 'text';
  options?: string[];
}

export interface QuestionFlow {
  questions: Question[];
  complete: boolean;
}

export const generateQuestions = (initialFeeling: string, responses: Record<string, string>): QuestionFlow => {
  const questions: Question[] = [];
  
  // Initial feeling question (always first)
  if (!responses['initial']) {
    return {
      questions: [{
        id: 'initial',
        text: 'How are you feeling today?',
        type: 'choice',
        options: ['Great', 'Good', 'Okay', 'Not Great', 'Poor']
      }],
      complete: false
    };
  }
  
  const feeling = responses['initial'];
  
  // If feeling great, we're done
  if (feeling === 'Great' || feeling === 'Good') {
    return {
      questions: [],
      complete: true
    };
  }
  
  // If not feeling great, ask follow-up questions
  if (feeling === 'Okay' || feeling === 'Not Great' || feeling === 'Poor') {
    // Ask about symptoms
    if (!responses['symptoms']) {
      return {
        questions: [{
          id: 'symptoms',
          text: 'Are you experiencing any of these symptoms?',
          type: 'choice',
          options: ['Headache', 'Body Ache', 'Fever', 'Fatigue', 'None']
        }],
        complete: false
      };
    }
    
    const symptom = responses['symptoms'];
    
    // If they have a fever, ask about temperature
    if (symptom === 'Fever' && !responses['temperature']) {
      return {
        questions: [{
          id: 'temperature',
          text: 'Have you checked your temperature?',
          type: 'choice',
          options: ['Yes - Normal', 'Yes - Elevated', 'No']
        }],
        complete: false
      };
    }
    
    // If they have symptoms, ask about severity
    if (symptom !== 'None' && !responses['severity']) {
      return {
        questions: [{
          id: 'severity',
          text: 'How would you rate the severity?',
          type: 'choice',
          options: ['Mild', 'Moderate', 'Severe']
        }],
        complete: false
      };
    }
    
    // Ask about sleep
    if (!responses['sleep']) {
      return {
        questions: [{
          id: 'sleep',
          text: 'How did you sleep last night?',
          type: 'choice',
          options: ['Well', 'Okay', 'Poorly']
        }],
        complete: false
      };
    }
    
    // Final question - any notes
    if (!responses['notes']) {
      return {
        questions: [{
          id: 'notes',
          text: 'Anything else you\'d like to note?',
          type: 'text',
        }],
        complete: false
      };
    }
  }
  
  return {
    questions: [],
    complete: true
  };
};
