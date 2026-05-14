import { useEffect, useState } from 'react';
import TitleInput from './TitleInput';
import Editor from './Editor';
import PollEditor from './PollEditor';
import { notifyReady, submitContent } from './bridge';

export default function App() {
  const [title, setTitle] = useState('');
  const [body, setBody] = useState('');
  const [pollEnabled, setPollEnabled] = useState(false);

  useEffect(() => {
    notifyReady();
  }, []);

  const handleSubmit = () => {
    submitContent({ title, body });
  };

  return (
    <div className="app">
      <TitleInput value={title} onChange={setTitle} />
      <Editor onChange={setBody} />
      <PollEditor enabled={pollEnabled} onToggle={() =>
setPollEnabled(!pollEnabled)} />
      <button className="submit-btn" onClick={handleSubmit}>
        등록
      </button>
    </div>
  );
}