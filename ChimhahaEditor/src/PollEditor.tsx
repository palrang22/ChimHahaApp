import { useState } from 'react';

interface PollEditorProps {
    enabled: boolean;
    onToggle: () => void;
}

export default function PollEditor({ enabled, onToggle }: PollEditorProps) {
    const [title, setTitle] = useState('');
    const [options, setOptions] = useState(['', '']);

    const addOption = () => setOptions([...options, '']);
    const removeOption = (index: number) =>
        setOptions(options.filter((_, i) => i !== index));
    const updateOption = (index: number, value: string) =>
        setOptions(options.map((opt, i) => (i === index ? value : opt)));

    return (
        <div className="poll-editor">
            <button className="poll-toggle" onClick={onToggle}>
                {enabled ? '투표 제거' : '+ 투표 추가'}
            </button>

            {enabled ?? (
                <div className="poll-body">
                    <input
                    className='poll-title-input'
                    placeholder='투표 제목'
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    />
                    {options.map((opt, i) => (
                        <div key={i} className="poll-option-row">
                            <input
                            placeholder={`선택지 ${i + 1}`}
                            value={opt}
                            onChange={(e) => updateOption(i, e.target.value)}
                            />
                            {options.length > 2 && (
                                <button onClick={() => removeOption(i)}>x</button>
                            )}
                            </div>
                    ))}
                    <button className='poll-add-option' onClick={addOption}>
                        + 선택지 추가
                    </button>
                </div>
            )}
        </div>
    );
}